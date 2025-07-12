module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam LOAD = 2'b01;
    localparam CALC = 2'b10;
    localparam DONE = 2'b11;

    reg [1:0] state, next_state;
    reg [3:0] count;        // Only needs 0-16 (4 bits)
    reg [15:0] areg;
    reg [31:0] breg_shifted [15:0]; // Pre-shifted versions
    reg [31:0] accumulator;

    // Pre-compute all possible shifted versions
    always @(*) begin
        for (integer j = 0; j < 16; j = j + 1) begin
            breg_shifted[j] = bin << j;
        end
    end

    // State machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 4'd0;
            areg <= 16'd0;
            accumulator <= 32'd0;
        end
        else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    count <= 4'd0;
                    accumulator <= 32'd0;
                end
                
                LOAD: begin
                    areg <= ain;
                    count <= 4'd0;
                end
                
                CALC: begin
                    if (areg[count]) begin
                        accumulator <= accumulator + breg_shifted[count];
                    end
                    count <= count + 1;
                end
                
                DONE: begin
                    // Hold values until next start
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = CALC;
            CALC: next_state = (count == 15) ? DONE : CALC;
            DONE: next_state = start ? LOAD : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Output assignments
    assign yout = (state == DONE) ? accumulator : 32'd0;
    assign done = (state == DONE);

endmodule