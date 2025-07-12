module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

// Define states
localparam IDLE = 2'b00;
localparam S1 = 2'b01;
localparam S2 = 2'b10;

reg [1:0] state, next_state;

// Asynchronous reset
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= IDLE;
    end else begin
        state <= next_state;
    end
end

// Next state logic
always @(*) begin
    case (state)
        IDLE: begin
            if (x) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (~x) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (x) begin
                next_state = S1;
                z = 1'b1;
            end else begin
                next_state = IDLE;
                z = 1'b0;
            end
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Output logic
always @(*) begin
    if ((state == S2) && x) begin
        z = 1'b1;
    end else if ((state != S2) || ~x) begin
        z = 1'b0;
    end
end

endmodule