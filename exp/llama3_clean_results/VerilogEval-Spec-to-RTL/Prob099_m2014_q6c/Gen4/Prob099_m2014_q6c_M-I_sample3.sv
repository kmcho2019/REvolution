module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

always @(y or w) begin
    Y1 = 0;
    Y2 = 0;
    Y3 = 0;
    Y4 = 0;
    
    // State A (000001)
    if (y[0]) begin
        Y1 = ~w;
    end
    
    // State B (000010)
    if (y[1]) begin
        Y3 = w;
    end
    
    // State C (000100)
    if (y[2]) begin
        Y2 = ~w;
        Y4 = w;
    end
    
    // State D (001000)
    if (y[3]) begin
        Y1 = ~w;
        Y4 = w;
    end
    
    // State E (010000)
    if (y[4]) begin
        Y3 = w;
    end
    
    // State F (100000)
    if (y[5]) begin
        Y2 = ~w;
        Y4 = w;
    end
end

endmodule