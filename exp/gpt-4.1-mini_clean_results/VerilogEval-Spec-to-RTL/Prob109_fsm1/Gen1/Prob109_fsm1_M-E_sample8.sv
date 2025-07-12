module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire in,
    output wire out
);

    // State encoding: A = 0, B = 1
    localparam A = 1'b0;
    localparam B = 1'b1;

    reg state;
    wire next_state;

    // Combinational next state logic
    assign next_state = (state == B) ? ((in == 1'b0) ? A : B)
                                     : ((in == 1'b0) ? B : A);

    // Asynchronous reset with state update on posedge clk or areset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    // Moore output logic as continuous assignment: output depends only on state
    assign out = (state == B) ? 1'b1 : 1'b0;

endmodule