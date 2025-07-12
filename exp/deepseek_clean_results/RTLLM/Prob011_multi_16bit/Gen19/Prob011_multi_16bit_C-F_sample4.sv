module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // State encoding (one-hot for better timing)
    localparam IDLE  = 2'b01;
    localparam CALC  = 2'b10;
    localparam DONE  = 2'b100;
    
    reg [2:0] state;
    reg [4:0] count;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
            areg <= 16'b0;
            breg <= 16'b0;
            acc <= 32'b0;
            yout <= 32'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= CALC;
                        areg <= ain;
                        breg <= bin;
                        acc <= 32'b0;
                        count <= 5'd0;
                        done <= 1'b0;
                    end
                end
                
                CALC: begin
                    if (count < 16) begin
                        // Conditional accumulation
                        if (areg[count]) begin
                            acc <= acc + (breg << count);
                        end
                        count <= count + 1;
                    end else begin
                        state <= DONE;
                        yout <= acc;
                        done <= 1'b1;
                    end
                end
                
                DONE: begin
                    state <= IDLE;
                    done <= 1'b0;
                end
            endcase
        end
    end

endmodule