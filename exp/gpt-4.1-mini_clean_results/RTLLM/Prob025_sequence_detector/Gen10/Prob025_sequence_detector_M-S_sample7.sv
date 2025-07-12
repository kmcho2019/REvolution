module sequence_detector (
    input  wire clk,
    input  wire reset_n,         // Active-low synchronous reset
    input  wire data_in,
    output reg  sequence_detected
);

    // State encoding
    localparam IDLE = 3'd0;
    localparam S1   = 3'd1; // matched '1'
    localparam S2   = 3'd2; // matched '10'
    localparam S3   = 3'd3; // matched '100'

    reg [2:0] state;

    always @(posedge clk) begin
        if (!reset_n) begin
            state <= IDLE;
            sequence_detected <= 1'b0;
        end else begin
            sequence_detected <= 1'b0; // default clear output
            case(state)
                IDLE: begin
                    if (data_in)
                        state <= S1;
                    else
                        state <= IDLE;
                end
                S1: begin
                    if (!data_in)
                        state <= S2;
                    else
                        state <= S1;
                end
                S2: begin
                    if (!data_in)
                        state <= S3;
                    else
                        state <= S1;
                end
                S3: begin
                    if (data_in) begin
                        state <= S1;
                        sequence_detected <= 1'b1; // sequence 1001 detected
                    end else
                        state <= IDLE;
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule