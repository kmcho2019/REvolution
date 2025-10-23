module TopModule(
    input clk,
    input reset,
    input in,
    output done
);

    // One-hot state encoding
    localparam IDLE   = 4'b0001;
    localparam RECEIVE = 4'b0010;
    localparam STOP    = 4'b0100;
    localparam ERROR   = 4'b1000;

    reg [3:0] state;
    reg [2:0] bit_count;
    reg [7:0] data_shift;

    // Combined state transition and output logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    bit_count <= 3'b0;
                    if (~in) state <= RECEIVE;  // Start bit detected
                end
                RECEIVE: begin
                    data_shift <= {in, data_shift[7:1]};  // LSB first
                    if (bit_count == 3'b111) begin
                        state <= STOP;
                    end
                    bit_count <= bit_count + 1;
                end
                STOP: begin
                    if (in) state <= IDLE;      // Valid stop bit
                    else state <= ERROR;        // Missing stop bit
                end
                ERROR: begin
                    if (in) state <= IDLE;      // Found stop bit
                end
                default: state <= IDLE;
            endcase
        end
    end

    // Output is high when we're in STOP state and in=1 (valid stop bit)
    assign done = (state == STOP) & in;

endmodule