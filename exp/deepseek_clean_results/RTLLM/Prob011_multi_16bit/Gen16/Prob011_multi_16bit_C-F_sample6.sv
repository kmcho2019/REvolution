module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // State definitions
    localparam IDLE = 1'b0;
    localparam RUN  = 1'b1;

    reg state;
    reg [4:0] count;
    reg [15:0] areg;
    reg [31:0] acc;
    reg done_r;

    // Continuous outputs
    assign yout = acc;
    assign done = done_r;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'b0;
            areg <= 16'b0;
            acc <= 32'b0;
            done_r <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done_r <= 1'b0;
                    if (start) begin
                        state <= RUN;
                        areg <= ain;
                        acc <= 32'b0;
                        count <= 5'b0;
                    end
                end
                
                RUN: begin
                    if (count == 0) begin
                        // First cycle - just load registers
                        count <= count + 1;
                    end else if (count <= 16) begin
                        // Accumulate if current bit is set
                        if (areg[count-1]) begin
                            acc <= acc + (bin << (count-1));
                        end
                        
                        // Update counter and check completion
                        if (count == 16) begin
                            done_r <= 1'b1;
                            state <= IDLE;
                        end else begin
                            count <= count + 1;
                        end
                    end
                end
            endcase
        end
    end

endmodule