module TopModule(
    input        clk,
    input        areset,
    input        in,
    output       out
);

reg state; // current state (0 for A, 1 for B)

// Sequential process to update the current state and determine the next state
always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 1'b1; // asynchronously reset into state B
    end else begin
        case(state)
            1'b0: // State A
                case(in)
                    1'b0: state <= 1'b1; // A --0--> B
                    1'b1: state <= 1'b0; // A --1--> A
                    default: state <= 1'b0;
                endcase
            1'b1: // State B
                case(in)
                    1'b0: state <= 1'b0; // B --0--> A
                    1'b1: state <= 1'b1; // B --1--> B
                    default: state <= 1'b1;
                endcase
            default: state <= 1'b1;
        endcase
    end
end

// Assign output based on the current state
assign out = state;

endmodule