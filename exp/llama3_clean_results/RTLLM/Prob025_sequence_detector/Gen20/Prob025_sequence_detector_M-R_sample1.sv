module sequence_detector(
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [2:0] current_state; // 3-bit state register

// Define the states
localparam IDLE = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;

// State machine logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        current_state <= IDLE;
        sequence_detected <= 0;
    end else begin
        case (current_state)
            IDLE: begin
                if (data_in == 1) begin
                    current_state <= S1;
                end else begin
                    current_state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 0) begin
                    current_state <= S2;
                end else begin
                    current_state <= IDLE;
                end
            end
            S2: begin
                if (data_in == 0) begin
                    current_state <= S3;
                end else begin
                    current_state <= IDLE;
                end
            end
            S3: begin
                if (data_in == 1) begin
                    current_state <= S4;
                end else begin
                    current_state <= IDLE;
                end
            end
            S4: begin
                current_state <= IDLE;
                sequence_detected <= 1;
            end
            default: begin
                current_state <= IDLE;
            end
        endcase
    end
end

// Reset the sequence_detected output when not in S4 state
always @(posedge clk) begin
    if (current_state != S4) begin
        sequence_detected <= 0;
    end
end

endmodule