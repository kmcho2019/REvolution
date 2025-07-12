module edge_detect (
    input  wire clk,
    input  wire rst_n,
    input  wire a,
    output reg  rise,
    output reg  down
);

    reg a_prev;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            a_prev <= 1'b0;
            rise   <= 1'b0;
            down   <= 1'b0;
        end else begin
            a_prev <= a;
            case ({a_prev, a})
                2'b01: begin  // Rising edge detected
                    rise <= 1'b1;
                    down <= 1'b0;
                end
                2'b10: begin  // Falling edge detected
                    rise <= 1'b0;
                    down <= 1'b1;
                end
                default: begin
                    // Maintain rise and down until corresponding edge reappears
                    rise <= rise;
                    down <= down;
                end
            endcase
        end
    end

endmodule