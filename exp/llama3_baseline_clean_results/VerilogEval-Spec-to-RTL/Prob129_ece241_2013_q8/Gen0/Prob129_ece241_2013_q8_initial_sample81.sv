module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

// Define states
parameter IDLE = 2'b00;
parameter SEQ_1 = 2'b01;
parameter SEQ_10 = 2'b10;

reg [1:0] current_state;
reg [1:0] next_state;

// Output logic
assign z = (current_state == SEQ_10 && x == 1'b1);

// Sequential logic
always @ (posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for next state
always @ (*) begin
    case (current_state)
        IDLE: begin
            if (x == 1'b1) begin
                next_state = SEQ_1;
            end else begin
                next_state = IDLE;
            end
        end
        SEQ_1: begin
            if (x == 1'b0) begin
                next_state = SEQ_10;
            end else begin
                next_state = SEQ_1;
            end
        end
        SEQ_10: begin
            if (x == 1'b1) begin
                next_state = SEQ_1; // Overlapping detection
            end else begin
                next_state = IDLE;
            end
        end
        default: next_state = IDLE;
    endcase
end

endmodule