module width_8to16 (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_in,
    input  wire [7:0]  data_in,
    output reg         valid_out,
    output reg  [15:0] data_out
);

    // FSM States
    localparam IDLE        = 1'b0;
    localparam WAIT_SECOND = 1'b1;

    reg state, next_state;

    reg [7:0] data_lock;       // Holds first byte
    reg       valid_out_reg;   // Delayed valid_out
    reg [15:0] data_out_reg;   // Delayed data_out

    // Next state and combinational logic
    always @(*) begin
        next_state = state;
        valid_out_reg = 1'b0;
        data_out_reg = data_out_reg; // hold by default

        case (state)
            IDLE: begin
                if (valid_in) begin
                    next_state = WAIT_SECOND;
                    // No output yet, store first byte
                end
            end
            WAIT_SECOND: begin
                if (valid_in) begin
                    next_state = IDLE;
                    // On next cycle, output concatenated data
                    valid_out_reg = 1'b1;
                    data_out_reg = {data_lock, data_in};
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state transitions and registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state       <= IDLE;
            data_lock   <= 8'd0;
            valid_out   <= 1'b0;
            data_out    <= 16'd0;
        end else begin
            state <= next_state;
            valid_out <= valid_out_reg;
            data_out <= data_out_reg;

            case (state)
                IDLE: begin
                    if (valid_in) begin
                        data_lock <= data_in;
                    end
                end
                WAIT_SECOND: begin
                    // data_lock holds first byte until output generated
                    // data_lock updated only in IDLE state
                end
            endcase
        end
    end

endmodule