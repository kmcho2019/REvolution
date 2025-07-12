module TopModule (
    input  clk,
    input  areset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // Using a single bit to represent the two states
reg [0:0] next_state;

// Combinational Logic
always_comb begin
    case(state)
        1'b0: out = 1'b0; // State OFF, out = 0
        1'b1: out = 1'b1; // State ON, out = 1
        default: out = 1'bx; // Default, undefined
    endcase
end

// Sequential Logic
always_ff @(posedge clk or posedge areset) begin
    if(areset) begin // Asynchronous reset to state OFF
        state <= 1'b0;
    end else begin
        case(state)
            1'b0: if(j) begin // Transition from OFF to ON when j=1
                        state <= 1'b1;
                    end else begin
                        state <= 1'b0; // Stay in OFF if j=0
                    end
            1'b1: if(k) begin // Transition from ON to OFF when k=1
                        state <= 1'b0;
                    end else begin
                        state <= 1'b1; // Stay in ON if k=0
                    end
            default: state <= 1'bx; // Default, undefined
        endcase
    end
end

endmodule