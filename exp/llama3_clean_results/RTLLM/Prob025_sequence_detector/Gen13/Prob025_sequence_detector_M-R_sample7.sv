module sequence_detector(
    input           clk,
    input           rst_n,
    input           data_in,
    output          sequence_detected
);

reg [2:0] state; // State register with 3 bits to represent 5 states
localparam IDLE = 3'b000;
localparam S1   = 3'b001;
localparam S2   = 3'b010;
localparam S3   = 3'b011;
localparam S4   = 3'b100;

reg [2:0] next_state; // Next state register
reg         sequence_detected_reg; // Output register

// Combinational logic for next state
always @(*) begin
    case (state)
        IDLE: begin
            if (data_in == 1'b1) begin
                next_state = S1;
            end else begin
                next_state = IDLE;
            end
            sequence_detected_reg = 1'b0;
        end
        S1: begin
            if (data_in == 1'b0) begin
                next_state = S2;
            end else begin
                next_state = IDLE;
            end
            sequence_detected_reg = 1'b0;
        end
        S2: begin
            if (data_in == 1'b0) begin
                next_state = S3;
            end else begin
                next_state = IDLE;
            end
            sequence_detected_reg = 1'b0;
        end
        S3: begin
            if (data_in == 1'b1) begin
                next_state = S4;
            end else begin
                next_state = IDLE;
            end
            sequence_detected_reg = 1'b0;
        end
        S4: begin
            sequence_detected_reg = 1'b1;
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
            sequence_detected_reg = 1'b0;
        end
    endcase
end

// Sequential logic for current state update
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        state <= next_state;
        sequence_detected <= sequence_detected_reg;
    end
end

endmodule