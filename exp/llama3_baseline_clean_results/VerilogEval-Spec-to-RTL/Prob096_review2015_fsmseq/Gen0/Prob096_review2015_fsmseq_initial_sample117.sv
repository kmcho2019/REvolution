module TopModule(
    input  clk,
    input  reset,
    input  data,
    output start_shifting
);

// Define the states of the FSM
localparam IDLE = 4'd0;
localparam S1    = 4'd1;
localparam S2    = 4'd2;
localparam S3    = 4'd3;
localparam S4    = 4'd4;
localparam SHIFT = 4'd5;

reg [3:0] state;
reg [3:0] next_state;

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        start_shifting <= 1'b0;
    end else begin
        state <= next_state;
        if (state == SHIFT) begin
            start_shifting <= 1'b1;
        end else if (state == IDLE) begin
            start_shifting <= 1'b0;
        end
    end
end

// Combinational logic
always @(*) begin
    case (state)
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
                next_state = S3;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (data == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = S2;
            end
        end
        S3: begin
            if (data == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            if (data == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        SHIFT: begin
            next_state = SHIFT;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

endmodule