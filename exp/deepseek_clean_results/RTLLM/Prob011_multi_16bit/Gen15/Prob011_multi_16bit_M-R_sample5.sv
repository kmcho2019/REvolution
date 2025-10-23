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
    localparam IDLE = 1'b0;
    localparam CALC = 1'b1;

    reg state;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] accumulator;
    reg [4:0] count;

    // Next state logic
    wire next_state;
    assign next_state = (!rst_n) ? IDLE :
                      (state == IDLE) ? (start ? CALC : IDLE) :
                      (state == CALC) ? ((count == 16) ? IDLE : CALC) : IDLE;

    // Shifted version of multiplier
    wire [31:0] shifted_b;
    assign shifted_b = {16'b0, breg} << count;

    // Bit being processed
    wire current_bit;
    assign current_bit = areg[count];

    // Accumulator update
    wire [31:0] next_accumulator;
    assign next_accumulator = (state == CALC && current_bit) ? 
                             accumulator + shifted_b : accumulator;

    // Counter update
    wire [4:0] next_count;
    assign next_count = (!rst_n) ? 5'd0 :
                       (state == IDLE) ? 5'd0 :
                       (state == CALC) ? count + 1 : count;

    // State transition and register updates
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            areg <= 16'd0;
            breg <= 16'd0;
            accumulator <= 32'd0;
            count <= 5'd0;
        end else begin
            state <= next_state;
            count <= next_count;
            accumulator <= next_accumulator;
            
            if (state == IDLE && start) begin
                areg <= ain;
                breg <= bin;
            end
        end
    end

    // Output assignments
    assign yout = (state == IDLE && count == 16) ? accumulator : 32'd0;
    assign done = (state == IDLE && count == 16);

endmodule