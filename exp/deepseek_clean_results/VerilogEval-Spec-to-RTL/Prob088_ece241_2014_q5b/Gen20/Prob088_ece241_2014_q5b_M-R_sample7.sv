module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    parameter A = 2'b01;
    parameter B = 2'b10;
    
    reg [1:0] state;
    wire [1:0] next_state;

    // Combinational next state logic
    assign next_state = (state == A) ? (x ? B : A) : B;

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= A;
        else
            state <= next_state;
    end

    // Combinational output logic
    assign z = (state == A) ? x : ~x;

endmodule