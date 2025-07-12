module TopModule (
    input clk,
    input areset,
    input load,
    input ena,
    input [3:0] data,
    output [3:0] q
);

reg [3:0] q_int;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        q_int <= 4'b0;
    end else begin
        if (load) begin
            q_int <= data;
        end else if (ena) begin
            q_int <= {1'b0, q_int[3:1]};
        end else begin
            q_int <= q_int;
        end
    end
end

assign q = q_int;

endmodule