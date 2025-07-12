module TopModule(
    input clk,
    input reset,
    input [2:0] s,
    output fr2,
    output fr1,
    output fr0,
    output dfr
);

reg [1:0] state; // state machine state
reg [1:0] prev_state; // previous state
reg [2:0] prev_s; // previous sensor state

// state machine states
localparam s0 = 2'b00; // above the highest sensor
localparam s1 = 2'b01; // between the highest and middle sensors
localparam s2 = 2'b10; // between the middle and lowest sensors
localparam s3 = 2'b11; // below the lowest sensor

always @(posedge clk) begin
    if (reset) begin
        state <= s3;
        prev_state <= s3;
        fr2 <= 1'b1;
        fr1 <= 1'b1;
        fr0 <= 1'b1;
        dfr <= 1'b1;
    end else begin
        prev_state <= state;
        prev_s <= s;

        case (s)
            3'b111: state <= s0;
            3'b011: state <= s1;
            3'b001: state <= s2;
            default: state <= s3;
        endcase

        case (state)
            s0: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b0;
                dfr <= 1'b0;
            end
            s1: begin
                fr2 <= 1'b0;
                fr1 <= 1'b0;
                fr0 <= 1'b1;
                dfr <= (prev_s < s);
            end
            s2: begin
                fr2 <= 1'b0;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= (prev_s < s);
            end
            s3: begin
                fr2 <= 1'b1;
                fr1 <= 1'b1;
                fr0 <= 1'b1;
                dfr <= 1'b1;
            end
        endcase
    end
end

endmodule