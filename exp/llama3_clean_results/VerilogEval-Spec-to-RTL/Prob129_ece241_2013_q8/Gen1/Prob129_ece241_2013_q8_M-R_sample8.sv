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
} state;

// State register
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= Idle;
    end else begin
        case (state)
            Idle: begin
                state <= x ? Got1 : Idle;
            end
            Got1: begin
                state <= x ? Got1 : Got10;
            end
            Got10: begin
                state <= x ? Got1 : Idle;
            end
            default: begin
                state <= Idle;
            end
        endcase
    end
end

// Output logic
assign z = (state == Got10 && x);

endmodule