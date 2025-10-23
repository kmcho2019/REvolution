module TopModule (
    input  clk,
    input  areset,
    input  in,
    output reg out
);

    // State encoding (2-bit binary)
    localparam [1:0]
        A = 2'd0,
        B = 2'd1,
        C = 2'd2,
        D = 2'd3;

    reg [1:0] current_state, next_state;

    // State register with asynchronous active-high reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state combinational logic with if-else
    always @(*) begin
        if (current_state == A) begin
            if (in == 1'b0)
                next_state = A;
            else
                next_state = B;
        end else if (current_state == B) begin
            if (in == 1'b0)
                next_state = C;
            else
                next_state = B;
        end else if (current_state == C) begin
            if (in == 1'b0)
                next_state = A;
            else
                next_state = D;
        end else /* current_state == D */ begin
            if (in == 1'b0)
                next_state = C;
            else
                next_state = B;
        end
    end

    // Output register driven by state (Moore machine)
    always @(posedge clk or posedge areset) begin
        if (areset)
            out <= 1'b0;
        else
            out <= (current_state == D);
    end

endmodule