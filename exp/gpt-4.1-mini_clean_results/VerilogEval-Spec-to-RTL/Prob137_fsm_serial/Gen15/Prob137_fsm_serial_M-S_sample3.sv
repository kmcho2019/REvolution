module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot state encoding for simplicity
    localparam IDLE  = 3'b001;
    localparam DATA  = 3'b010;
    localparam ERROR = 3'b100;

    reg [2:0] state, next_state;
    reg [3:0] bit_count; // 4-bit for counting up to 8 bits

    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 0;
            done      <= 0;
        end else begin
            state <= next_state;
            done  <= 0; // default no pulse

            case (state)
                IDLE: begin
                    bit_count <= 0;
                end
                DATA: begin
                    bit_count <= bit_count + 1;
                end
                ERROR: begin
                    bit_count <= 0;
                end
            endcase

            // Generate done pulse when stop bit detected correctly
            if (state == DATA && bit_count == 8) begin
                if (in == 1'b1) begin
                    done <= 1'b1; // stop bit valid -> done pulse
                end
            end
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = DATA;  // start bit detected
            end
            DATA: begin
                if (bit_count == 8) begin
                    if (in == 1'b1)
                        next_state = IDLE;  // valid stop bit, done
                    else
                        next_state = ERROR; // framing error
                end
            end
            ERROR: begin
                if (in == 1'b1)
                    next_state = IDLE;     // recovered on stop bit
            end
        endcase
    end

endmodule