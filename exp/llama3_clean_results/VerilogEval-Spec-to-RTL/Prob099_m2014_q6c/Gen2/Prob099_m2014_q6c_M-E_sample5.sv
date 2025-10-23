module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

reg [5:0] currentState;

always @(y or w) begin
    case (1'b1)
        y[0]: // State A
            Y1 = ~w;
        y[1]: // State B
            begin
                Y2 = ~w;
                Y3 = w;
            end
        y[2]: // State C
            Y3 = w;
        y[3]: // State D
            begin
                Y4 = ~w;
                Y1 = w;
            end
        y[4]: // State E
            begin
                Y4 = w;
                Y3 = w;
            end
        y[5]: // State F
            begin
                Y2 = ~w;
                Y3 = w;
            end
    endcase
end

endmodule