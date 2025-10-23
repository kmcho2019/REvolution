module multi_16bit (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        start,
    input  wire [15:0] ain,
    input  wire [15:0] bin,
    output reg  [31:0] yout,
    output reg         done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        RUN  = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t state, next_state;

    reg [4:0] bit_pos;            // bit position counter: 0 to 16
    reg [15:0] areg;              // multiplicand register
    reg [15:0] breg;              // multiplier register
    reg [31:0] acc;               // accumulator for product

    wire bit_to_process = areg[bit_pos];

    // Next accumulator value: add shifted multiplier if bit_to_process is set
    wire [31:0] shifted_breg = {16'd0, breg} << bit_pos;
    wire [31:0] acc_next = acc + (bit_to_process ? shifted_breg : 32'd0);

    // FSM sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state   <= IDLE;
            bit_pos <= 5'd0;
            areg    <= 16'd0;
            breg    <= 16'd0;
            acc     <= 32'd0;
            yout    <= 32'd0;
            done    <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        areg    <= ain;
                        breg    <= bin;
                        acc     <= 32'd0;
                        bit_pos <= 5'd0;
                    end
                end
                RUN: begin
                    // Accumulate if bit is set
                    acc <= acc_next;

                    // Increment bit position
                    bit_pos <= bit_pos + 1;
                end
                DONE: begin
                    done <= 1'b1;
                    yout <= acc;
                end
            endcase
        end
    end

    // FSM combinational logic
    always @(*) begin
        case (state)
            IDLE:  next_state = start ? RUN : IDLE;
            RUN:   next_state = (bit_pos == 16) ? DONE : RUN;
            DONE:  next_state = start ? RUN : IDLE; // allow restart on start
            default: next_state = IDLE;
        endcase
    end

endmodule