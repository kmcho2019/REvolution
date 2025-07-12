module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    reg [2:0] current_grant;

    always @(posedge clk) begin
        if (!resetn) begin
            current_grant <= 3'b000;
        end
        else begin
            // Priority encoder with hold functionality
            case (1'b1)
                // Maintain current grant if request still active
                current_grant[0] && r[0]: current_grant <= 3'b001;
                current_grant[1] && r[1]: current_grant <= 3'b010;
                current_grant[2] && r[2]: current_grant <= 3'b100;
                
                // New priority-based grants
                r[0]: current_grant <= 3'b001;
                r[1] && !r[0]: current_grant <= 3'b010;
                r[2] && !(|r[1:0]): current_grant <= 3'b100;
                
                // Default: no grants
                default: current_grant <= 3'b000;
            endcase
        end
    end

    assign g = current_grant;

endmodule