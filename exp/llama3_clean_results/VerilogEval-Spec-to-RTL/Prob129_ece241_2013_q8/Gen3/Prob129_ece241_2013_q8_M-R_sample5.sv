module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define states
enum logic [1:0] {
    Idle,
    Got1,
    Got10
} state, next_state;

// Next state logic
always_comb begin
    case (state)
        Idle: begin
            next_state = x ? Got1 : Idle;
        end
        Got1: begin
            next_state = x ? Got1 : Got10;
        end
        Got10: begin
            next_state = x ? Got1 : Idle;
        end
        default: begin
            next_state = Idle;
        end
    endcase
end

// State register
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= Idle;
    end else begin
        state <= next_state;
    end
end

// Output logic
assign z = (state == Got10 && x);

endmodule