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
    reg [4:0] count;  // Proper 5-bit counter for 0-16
    reg [15:0] areg, breg;
    reg [31:0] accumulator;
    wire [31:0] shifted_b;

    // Power-optimized shift calculation (only during CALC state)
    assign shifted_b = (state == CALC) ? {16'b0, breg} << count : 32'b0;

    // Optimized next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: next_state = start ? LOAD : IDLE;
            LOAD: next_state = CALC;
            CALC: next_state = (count == 16) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // State transition and datapath (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            accumulator <= 32'd0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    count <= 5'd0;
                    accumulator <= 32'd0;
                end
                
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    count <= 5'd0;
                end
                
                CALC: begin
                    if (areg[count]) begin
                        accumulator <= accumulator + shifted_b;
                    end
                    count <= count + 1;
                end
                
                DONE: begin
                    // Hold values until next start
                end
            endcase
        end
    end

    // Output assignments with proper gating
    assign yout = (state == DONE) ? accumulator : 32'd0;
    assign done = (state == DONE);

endmodule