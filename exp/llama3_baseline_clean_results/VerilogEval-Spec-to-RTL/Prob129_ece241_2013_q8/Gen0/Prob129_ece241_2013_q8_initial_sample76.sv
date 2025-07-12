module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

// Define states
parameter IDLE = 2'b00;
parameter STATE1 = 2'b01;
parameter STATE2 = 2'b10;

reg [1:0] state;
reg [1:0] next_state;

// Asynchronous reset
always @(posedge clk or negedge aresetn)
begin
    if (~aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// State transitions
always @(*)
begin
    case(state)
        IDLE: begin
            if (x) begin
                next_state <= STATE1;
            end else begin
                next_state <= IDLE;
            end
        end
        STATE1: begin
            if (~x) begin
                next_state <= STATE2;
            end else begin
                next_state <= STATE1;
            end
        end
        STATE2: begin
            if (x) begin
                next_state <= STATE1;
            end else begin
                next_state <= IDLE;
            end
        end
        default: next_state <= IDLE;
    endcase
end

// Output logic
assign z = (state == STATE2 && x);

endmodule