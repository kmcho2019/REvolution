module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [15:0] areg;        // Multiplicand register
    reg [15:0] breg;        // Multiplier register
    reg [31:0] yout_r;      // Product register
    reg [31:0] next_yout;   // Pipeline register
    reg [3:0] i;           // Reduced to 4-bit counter
    reg done_r;            // Internal done flag
    reg active;            // Active operation flag
    wire clk_gated;        // Gated clock signal

    // Clock gating for power optimization
    assign clk_gated = clk & (start | active | !rst_n);

    // Barrel shifter function
    function [31:0] barrel_shift;
        input [15:0] data;
        input [3:0] shift;
        begin
            case(shift)
                4'd0: barrel_shift = {16'b0, data};
                4'd1: barrel_shift = {15'b0, data, 1'b0};
                4'd2: barrel_shift = {14'b0, data, 2'b0};
                4'd3: barrel_shift = {13'b0, data, 3'b0};
                4'd4: barrel_shift = {12'b0, data, 4'b0};
                4'd5: barrel_shift = {11'b0, data, 5'b0};
                4'd6: barrel_shift = {10'b0, data, 6'b0};
                4'd7: barrel_shift = {9'b0, data, 7'b0};
                4'd8: barrel_shift = {8'b0, data, 8'b0};
                4'd9: barrel_shift = {7'b0, data, 9'b0};
                4'd10: barrel_shift = {6'b0, data, 10'b0};
                4'd11: barrel_shift = {5'b0, data, 11'b0};
                4'd12: barrel_shift = {4'b0, data, 12'b0};
                4'd13: barrel_shift = {3'b0, data, 13'b0};
                4'd14: barrel_shift = {2'b0, data, 14'b0};
                4'd15: barrel_shift = {1'b0, data, 15'b0};
                default: barrel_shift = {16'b0, data};
            endcase
        end
    endfunction

    always @(posedge clk_gated or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            breg <= 16'b0;
            yout_r <= 32'b0;
            next_yout <= 32'b0;
            i <= 4'b0;
            done_r <= 1'b0;
            active <= 1'b0;
        end
        else begin
            if (start && !active) begin
                // Start new multiplication
                areg <= ain;
                breg <= bin;
                yout_r <= 32'b0;
                next_yout <= 32'b0;
                i <= 4'b0;
                done_r <= 1'b0;
                active <= 1'b1;
            end
            else if (active) begin
                if (i < 15) begin
                    // Normal operation
                    if (areg[i]) begin
                        next_yout <= yout_r + barrel_shift(breg, i);
                    end
                    else begin
                        next_yout <= yout_r;
                    end
                    
                    yout_r <= next_yout;
                    i <= i + 1;
                    
                    // Early termination if multiplicand becomes zero
                    if (areg == 16'b0) begin
                        active <= 1'b0;
                        done_r <= 1'b1;
                    end
                end
                else if (i == 15) begin
                    // Final cycle
                    if (areg[i]) begin
                        yout_r <= next_yout + barrel_shift(breg, i);
                    end
                    else begin
                        yout_r <= next_yout;
                    end
                    
                    active <= 1'b0;
                    done_r <= 1'b1;
                end
            end
            else begin
                // Idle state
                done_r <= 1'b0;
            end
        end
    end

    // Output assignments
    always @(*) begin
        yout = yout_r;
        done = done_r;
    end

endmodule