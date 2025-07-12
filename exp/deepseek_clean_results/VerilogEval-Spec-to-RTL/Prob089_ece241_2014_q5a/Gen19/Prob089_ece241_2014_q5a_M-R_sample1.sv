module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State definitions
    localparam COPY = 1'b0;
    localparam INVERT = 1'b1;
    
    reg state;
    wire next_state;

    // Combinational output logic
    assign z = (state == COPY) ? x : ~x;

    // Next state logic
    assign next_state = (state == COPY && x) ? INVERT : state;

    // Sequential state transition
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= COPY;
        end else begin
            state <= next_state;
        end
    end

endmodule