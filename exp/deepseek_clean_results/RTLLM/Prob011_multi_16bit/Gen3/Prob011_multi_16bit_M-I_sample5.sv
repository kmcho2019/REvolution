module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    reg [15:0] areg;       // Multiplicand register
    reg [15:0] breg;       // Multiplier register
    reg [31:0] acc;        // Accumulator
    reg [31:0] shifted_b;  // Shifted multiplier value
    reg [3:0] i;           // 4-bit counter (0-15)
    reg state;             // 0: idle, 1: running
    reg add_en;            // Add enable signal

    // Clock gating control
    wire clk_en = start | (state & (i != 4'b1111));

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset all registers
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            shifted_b <= 32'b0;
            i <= 4'b0;
            state <= 1'b0;
            add_en <= 1'b0;
            done <= 1'b0;
            yout <= 32'b0;
        end
        else if (clk_en) begin
            // State machine
            case (state)
                1'b0: begin // Idle state
                    if (start) begin
                        areg <= ain;
                        breg <= bin;
                        acc <= 32'b0;
                        i <= 4'b0;
                        state <= 1'b1;
                        done <= 1'b0;
                    end
                end
                
                1'b1: begin // Running state
                    // Stage 1: Shift operation (every cycle)
                    shifted_b <= (breg << i);
                    
                    // Stage 2: Conditional add (delayed by 1 cycle)
                    if (add_en && areg[i-1]) begin
                        acc <= acc + shifted_b;
                    end
                    
                    // Update counter and control signals
                    add_en <= 1'b1;
                    if (i == 4'b1111) begin
                        state <= 1'b0;
                        done <= 1'b1;
                        yout <= (areg[15] && add_en) ? acc + shifted_b : acc;
                    end
                    else begin
                        i <= i + 1;
                    end
                end
            endcase
        end
    end

endmodule