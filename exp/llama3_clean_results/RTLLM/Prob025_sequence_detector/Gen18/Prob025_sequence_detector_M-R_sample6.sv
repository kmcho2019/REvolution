module sequence_detector(
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

reg [2:0] state; // 3-bit state register

// Define the states
localparam IDLE = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;

// State machine logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        sequence_detected <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    state <= S1;
                end else begin
                    state <= IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    state <= S2;
                end else begin
                    state <= IDLE;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    state <= S3;
                end else begin
                    state <= IDLE;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    state <= S4;
                end else begin
                    state <= IDLE;
                end
            end
            S4: begin
                sequence_detected <= 1'b1;
                state <= IDLE;
            end
        endcase
    end
end

// Reset sequence_detected after one clock cycle
always @(posedge clk) begin
    if (state == S4) begin
        sequence_detected <= 1'b0;
    end
end

endmodule