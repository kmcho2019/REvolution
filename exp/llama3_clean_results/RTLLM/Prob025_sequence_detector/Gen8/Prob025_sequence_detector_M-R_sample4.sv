module sequence_detector(
    input clk,
    input reset_n,
    input data_in,
    output sequence_detected
);

reg [2:0] state;
reg sequence_detected_reg;

localparam IDLE = 3'b000;
localparam S1 = 3'b001;
localparam S2 = 3'b010;
localparam S3 = 3'b011;
localparam S4 = 3'b100;

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    state <= S1;
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
                state <= IDLE;
            end
            default: state <= IDLE;
        endcase
    end
end

always @(posedge clk or negedge reset_n) begin
    if (!reset_n) begin
        sequence_detected_reg <= 1'b0;
    end else begin
        case (state)
            S4: begin
                sequence_detected_reg <= 1'b1;
            end
            default: sequence_detected_reg <= 1'b0;
        endcase
    end
end

assign sequence_detected = sequence_detected_reg;

endmodule