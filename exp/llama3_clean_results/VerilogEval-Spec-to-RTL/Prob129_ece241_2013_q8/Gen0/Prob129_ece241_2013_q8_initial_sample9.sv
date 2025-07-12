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

// State register
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= Idle;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        Idle: begin
            if (x == 1'b1) begin
                next_state = Got1;
            end else begin
                next_state = Idle;
            end
        end
        Got1: begin
            if (x == 1'b0) begin
                next_state = Got10;
            end else begin
                next_state = Got1;
            end
        end
        Got10: begin
            if (x == 1'b1) begin
                next_state = Got1;
            end else begin
                next_state = Idle;
            end
        end
        default: begin
            next_state = Idle;
        end
    endcase
end

// Output logic
assign z = (state == Got10 && x == 1'b1);

endmodule