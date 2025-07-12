module TopModule(
    input clk,
    input aresetn,
    input x,
    output z
);

// Define states
localparam IDLE = 2'b00;
localparam FIRST_ONE = 2'b01;
localparam AFTER_ZERO = 2'b10;

reg [1:0] current_state, next_state;

// Output logic
assign z = (current_state == AFTER_ZERO && x == 1'b1);

// Sequential logic
always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic
always @* begin
    case (current_state)
        IDLE: begin
            if (x == 1'b1) begin
                next_state = FIRST_ONE;
            end else begin
                next_state = IDLE;
            end
        end
        FIRST_ONE: begin
            if (x == 1'b0) begin
                next_state = AFTER_ZERO;
            end else begin
                next_state = FIRST_ONE;
            end
        end
        AFTER_ZERO: begin
            if (x == 1'b1) begin
                next_state = FIRST_ONE;
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule