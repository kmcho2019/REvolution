module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [1:0] state; // 0: initial, 1: computation
reg [31:0] count; // counter for tracking '1's

always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 0;
        count <= 0;
        z <= 0;
    end else begin
        case (state)
            0: begin
                if (x) begin
                    state <= 1;
                    count <= 1;
                    z <= 1;
                end
            end
            1: begin
                if (x) begin
                    count <= count + 1;
                    z <= ~z;
                end else begin
                    z <= ~z;
                end
            end
        endcase
    end
end

endmodule