module TopModule(
    input [5:0] y,
    input w,
    output reg Y1,
    output reg Y3
);

always @(y or w) begin
    case (1'b1)
        y[0]: Y1 = ~w; // State A
        y[1]: Y3 = w; // State B
        y[2]: Y3 = w; // State C
        y[3]: Y3 = w; // State D
        y[4]: Y3 = w; // State E
        y[5]: Y3 = w; // State F
    endcase
end

endmodule