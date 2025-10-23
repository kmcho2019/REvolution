module TopModule(
    input  clk,
    input  reset,
    input  [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [2:0] prevState;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        prevState <= 3'b000;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        if (s == 3'b111) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b0;
            dfr <= 1'b0;
        end else if (s == 3'b110) begin
            fr2 <= 1'b0;
            fr1 <= 1'b0;
            fr0 <= 1'b1;
            if (prevState < 3'b110) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s == 3'b100) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if (prevState < 3'b100) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s == 3'b000) begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            dfr <= 1'b1;
        end else if (s == 3'b010) begin
            fr2 <= 1'b0;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if (prevState < 3'b010) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end else if (s == 3'b001) begin
            fr2 <= 1'b1;
            fr1 <= 1'b1;
            fr0 <= 1'b1;
            if (prevState < 3'b001) begin
                dfr <= 1'b1;
            end else begin
                dfr <= 1'b0;
            end
        end
        prevState <= s;
    end
end

endmodule