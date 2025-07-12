module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam LOAD = 2'b01;
    localparam CALC = 2'b10;
    localparam DONE = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] count;        // 4-bit counter (0-15)
    reg [15:0] areg;        // Multiplicand register
    reg [15:0] breg;        // Multiplier register
    reg [31:0] acc;         // Accumulator
    wire [15:0][31:0] shifted_b; // Pre-computed shifted versions

    // Pre-compute all possible shifted versions of breg
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : shift_gen
            assign shifted_b[i] = breg << i;
        end
    endgenerate

    // State machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            acc <= 32'd0;
        end
        else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    count <= 4'd0;
                    acc <= 32'd0;
                end
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    count <= 4'd0;
                end
                CALC: begin
                    if (areg[count]) begin
                        acc <= acc + shifted_b[count];
                    end
                    count <= count + 1;
                end
                DONE: begin
                    // Hold values until next operation
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = CALC;
            CALC: next_state = (count == 4'd15) ? DONE : CALC;
            DONE: next_state = start ? LOAD : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output assignments
    assign yout = (state == DONE) ? acc : 32'd0;
    assign done = (state == DONE);

endmodule