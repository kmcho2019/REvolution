module TopModule(
    input clk,
    input areset,
    input in,
    output reg out
);

// State encoding
localparam A = 2'd0,
           B = 2'd1,
           C = 2'd2,
           D = 2'd3;

reg [1:0] state, next_state;
reg next_out;

// Sequential state and output registers with asynchronous reset
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
        out <= 1'b0;
    end else begin
        state <= next_state;
        out <= next_out;
    end
end

// Combinational next state and output logic
always @(*) begin
    case(state)
        A: begin
            next_state = in ? B : A;
            next_out = 1'b0;
        end
        B: begin
            next_state = in ? B : C;
            next_out = 1'b0;
        end
        C: begin
            next_state = in ? D : A;
            next_out = 1'b0;
        end
        D: begin
            next_state = in ? B : C;
            next_out = 1'b1;
        end
        default: begin
            next_state = A;
            next_out = 1'b0;
        end
    endcase
end

endmodule