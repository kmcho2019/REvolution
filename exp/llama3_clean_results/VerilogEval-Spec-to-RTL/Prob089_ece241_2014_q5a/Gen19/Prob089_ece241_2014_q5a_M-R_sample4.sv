module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg detector;

assign z = detector ? ~x : x;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        detector <= 0;
    end else begin
        detector <= detector || x;
    end
end

endmodule