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

    // Next state and output logic (combinational)
    wire start_detected = (state == IDLE) & ~in;
    wire all_bits_received = (bit_count == 3'b111);
    wire stop_valid = (state == STOP) & in;
    wire error_resolved = (state == ERROR) & in;

    wire [3:0] next_state = 
        reset ? IDLE :
        start_detected ? RECEIVE :
        all_bits_received ? STOP :
        stop_valid ? IDLE :
        error_resolved ? IDLE :
        state;

    assign done = (state == STOP) & in;

    // Sequential logic (single always block)
    always @(posedge clk) begin
        state <= next_state;

        if (reset) begin
            bit_count <= 0;
            data_shift <= 0;
        end else begin
            case (1'b1) // synthesis parallel_case
                next_state[1]: begin // RECEIVE
                    bit_count <= bit_count + 1;
                    data_shift <= {in, data_shift[7:1]};
                end
                next_state[0]: begin // IDLE
                    bit_count <= 0;
                end
            endcase
        end
    end

endmodule