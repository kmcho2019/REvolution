module sequence_detector(
    input  clk,
    input  reset_n,
    input  data_in,
    output sequence_detected
);

// Parameterized enumeration for the states
localparam IDLE = 4'd0;
localparam S1   = 4'd1;
localparam S2   = 4'd2;
localparam S3   = 4'd3;
localparam S4   = 4'd4;

// Current state and next state
reg [3:0] current_state;
reg [3:0] next_state;

// Output signal
reg sequence_detected_reg;

// Assign output signal
assign sequence_detected = sequence_detected_reg;

// FSM combinational logic
always @(*) begin
    case (current_state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S1;
            end
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = S3;
            end
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
        end
        S4: begin
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// FSM sequential logic
always @(posedge clk or negedge reset_n) begin
    if (~reset_n) begin
        current_state <= IDLE;
        sequence_detected_reg <= 1'b0;
    end else begin
        current_state <= next_state;
        if (current_state == S4) begin
            sequence_detected_reg <= 1'b1;
        end else begin
            sequence_detected_reg <= 1'b0;
        end
    end
end

endmodule