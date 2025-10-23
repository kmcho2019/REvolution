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

    reg [1:0] state;
    reg [3:0] count;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] accumulator;
    wire [31:0] shifted_b;

    // Shifted version of multiplier
    assign shifted_b = {16'b0, breg} << count;

    // Next state logic (combinational)
    wire [1:0] next_state;
    assign next_state = 
        (!rst_n) ? IDLE :
        (state == IDLE) ? (start ? LOAD : IDLE) :
        (state == LOAD) ? CALC :
        (state == CALC) ? ((count == 15) ? DONE : CALC) :
        (state == DONE) ? (start ? LOAD : IDLE) : IDLE;

    // State transition (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            accumulator <= 32'd0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    count <= 4'd0;
                    accumulator <= 32'd0;
                end
                
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    count <= 4'd0;
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

    // Output assignments
    assign yout = (state == DONE) ? accumulator : 32'd0;
    assign done = (state == DONE);

endmodule