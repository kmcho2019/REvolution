module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state;

always @(posedge clock) begin
    if (a && state == 2'b00) begin
        state <= 2'b10;
    end else if (~a && state == 2'b10) begin
        state <= 2'b00;
    end
end

always @(negedge clock) begin
    if (a) begin
        state <= 2'b01;
    end else if (state == 2'b10) begin
        state <= 2'b00;
    end
end

assign p = (clock && (state == 2'b10 || (state == 2'b01 && a)))? 1'b1 : 1'b0;
assign q = (state == 2'b01 || state == 2'b10)? 1'b1 : a;

endmodule