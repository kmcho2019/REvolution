module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

reg [1:0] state; // IDLE, RUNNING
reg seen_one; // flag to indicate if we've seen the first '1'
reg [1:0] count; // counter for the number of '1's seen

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0; // IDLE
        seen_one <= 0;
        count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin // IDLE
                if (~areset) begin
                    state <= 1; // RUNNING
                    seen_one <= 0;
                    count <= 0;
                end
                z <= 0;
            end
            1: begin // RUNNING
                if (areset) begin
                    state <= 0; // IDLE
                end else begin
                    z <= ~x; // flip the input bit
                    if (x) begin
                        seen_one <= 1;
                    end
                    if (seen_one) begin
                        if (x == 0) begin // add 1 at the end
                            z <= 1;
                        end
                    end
                end
            end
        endcase
    end
end

endmodule