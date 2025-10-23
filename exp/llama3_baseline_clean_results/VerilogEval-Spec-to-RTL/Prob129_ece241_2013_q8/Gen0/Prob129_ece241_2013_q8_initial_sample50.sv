module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

// Define the states
parameter State1 = 2'b00;
parameter State2 = 2'b01;
parameter State3 = 2'b10;

// Asynchronous reset
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= State1;
    end else begin
        state <= next_state;
    end
end

// State machine logic
always @(*) begin
    case (state)
        State1: begin
            if (x) begin
                next_state = State2;
            end else begin
                next_state = State1;
            end
        end
        State2: begin
            if (x) begin
                next_state = State2;
            end else begin
                next_state = State3;
            end
        end
        State3: begin
            if (x) begin
                next_state = State2;
            end else begin
                next_state = State1;
            end
        end
        default: next_state = State1;
    endcase
end

// Output logic
assign z = (state == State3) && x;

endmodule