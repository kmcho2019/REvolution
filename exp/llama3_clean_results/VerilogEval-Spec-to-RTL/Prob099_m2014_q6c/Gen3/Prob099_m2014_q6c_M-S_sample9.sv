module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

always @(y or w) begin
    case (1'b1)
        y[0]: // State A
            Y1 = ~w;
        y[1]: // State B
            Y3 = w;
        y[2]: // State C
            Y3 = w;
        y[3]: // State D
            Y3 = w;
        y[4]: // State E
            Y3 = w;
        y[5]: // State F
            Y3 = w;
    endcase
end

endmodule