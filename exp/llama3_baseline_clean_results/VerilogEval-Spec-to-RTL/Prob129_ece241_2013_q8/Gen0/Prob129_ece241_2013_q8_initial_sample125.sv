module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

// Define states
localparam IDLE = 2'b00;
localparam GOT_1 = 2'b01;
localparam GOT_01 = 2'b10;

reg [1:0] state, next_state;

// Initialize state
initial state = IDLE;

// Next state logic
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// State machine logic
always @(*) begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state = GOT_1;
            end else begin
                next_state = IDLE;
            end
        end
        GOT_1: begin
            if (~x) begin
                next_state = GOT_01;
            end else begin
                next_state = GOT_1;
            end
        end
        GOT_01: begin
            if (x) begin
                next_state = GOT_1;
            end else begin
                next_state = IDLE;
            end
        end
    endcase
end

// Output logic
always @(*) begin
    if ((state == GOT_01) && x) begin
        z = 1'b1;
    end else begin
        z = 1'b0;
    end
end

endmodule