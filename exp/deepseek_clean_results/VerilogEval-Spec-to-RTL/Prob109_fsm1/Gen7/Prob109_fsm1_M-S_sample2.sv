module TopModule (
    input clk,
    input areset,
    input in,
    output out
);

    reg state;
    
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 1'b1;  // Reset to state B (1)
        else
            state <= in ? state : ~state;  // XOR-like transition
    end

    assign out = state;

endmodule