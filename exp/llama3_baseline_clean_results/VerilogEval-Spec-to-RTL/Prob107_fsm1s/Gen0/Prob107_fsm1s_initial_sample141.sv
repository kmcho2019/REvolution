module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    reg [0:0] state; // 0: A, 1: B
    reg [0:0] next_state;

    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            state <= 1'b1; // reset to state B
        end else begin
            state <= next_state;
        end
    end

    always @ (*) begin
        case (state)
            1'b0: begin // state A
                if (in == 1'b0) begin
                    next_state = 1'b1; // A -> B
                end else begin
                    next_state = 1'b0; // A -> A
                end
            end
            1'b1: begin // state B
                if (in == 1'b0) begin
                    next_state = 1'b1; // B -> B
                end else begin
                    next_state = 1'b1; // B -> B
                end
            end
        endcase
    end

    assign out = state; // output is the current state

endmodule