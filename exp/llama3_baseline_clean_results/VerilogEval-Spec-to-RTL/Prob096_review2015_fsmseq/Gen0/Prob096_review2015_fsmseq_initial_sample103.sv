module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// Define states
parameter IDLE = 4'b0000,
           S1   = 4'b0001,
           S2   = 4'b0010,
           S3   = 4'b0011,
           FOUND = 4'b0100;

reg [3:0] current_state;
reg [3:0] next_state;

// Output logic
assign start_shifting = (current_state == FOUND) ? 1'b1 : 1'b0;

// FSM logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data == 1'b1) begin
                next_state = S2;
            end else if (data == 1'b0) begin
                next_state = IDLE;
            end
        end
        S2: begin
            if (data == 1'b0) begin
                next_state = S3;
            end else if (data == 1'b1) begin
                next_state = S1;
            end
        end
        S3: begin
            if (data == 1'b1) begin
                next_state = FOUND;
            end else if (data == 1'b0) begin
                next_state = IDLE;
            end
        end
        FOUND: begin
            next_state = FOUND;
        end
    endcase
end

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

endmodule