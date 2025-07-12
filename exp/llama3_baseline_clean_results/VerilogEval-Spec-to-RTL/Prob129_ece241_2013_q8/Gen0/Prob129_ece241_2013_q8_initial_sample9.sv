module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] current_state;
reg [1:0] next_state;

// Define the states
parameter State0 = 2'b00;
parameter State1 = 2'b01;
parameter State2 = 2'b10;

// Next state logic
always @(*) begin
    case(current_state)
        State0: begin
            if(x) begin
                next_state = State1;
            end else begin
                next_state = State0;
            end
        end
        State1: begin
            if(x) begin
                next_state = State1;
            end else begin
                next_state = State2;
            end
        end
        State2: begin
            if(x) begin
                next_state = State1;
            end else begin
                next_state = State0;
            end
        end
        default: next_state = State0;
    endcase
end

// Output logic (Mealy machine)
assign z = (current_state == State2) && x;

// Sequential logic with asynchronous reset
always @(posedge clk or negedge aresetn) begin
    if(~aresetn) begin
        current_state <= State0;
    end else begin
        current_state <= next_state;
    end
end

endmodule