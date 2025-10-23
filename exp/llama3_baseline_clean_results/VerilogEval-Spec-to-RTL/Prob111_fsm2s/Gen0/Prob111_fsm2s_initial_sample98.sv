module TopModule(clk, reset, j, k, out);
    input clk, reset, j, k;
    output reg out;

    reg [1:0] state; // Encoding states: OFF = 0, ON = 1
    localparam OFF = 1'b0;
    localparam ON = 1'b1;

    always @(posedge clk) begin
        if (reset) begin
            state <= OFF; // Synchronous reset to OFF state
        end else begin
            case (state)
                OFF: begin
                    if (j) begin
                        state <= ON;
                    end else begin
                        state <= OFF;
                    end
                end
                ON: begin
                    if (k) begin
                        state <= OFF;
                    end else begin
                        state <= ON;
                    end
                end
                default: state <= OFF; // Default to OFF state
            endcase
        end
    end

    always @(*) begin
        case (state)
            OFF: out = 1'b0;
            ON: out = 1'b1;
            default: out = 1'b0; // Default output to 0
        endcase
    end
endmodule