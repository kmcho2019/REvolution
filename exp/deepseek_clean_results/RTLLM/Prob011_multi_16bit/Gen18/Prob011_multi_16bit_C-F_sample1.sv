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
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state;
    reg [4:0] count;  // Properly sized for 0-16
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] accumulator;
    wire [31:0] shifted_b;

    // Shifted version of multiplier (computed when needed)
    assign shifted_b = {16'b0, breg} << count;

    // Next state logic (combinational)
    wire [1:0] next_state;
    assign next_state = 
        (!rst_n) ? IDLE :
        (state == IDLE) ? (start ? CALC : IDLE) :
        (state == CALC) ? ((count == 16) ? DONE : CALC) :
        (state == DONE) ? IDLE : IDLE;

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
                    if (start) begin
                        areg <= ain;
                        breg <= bin;
                        accumulator <= 32'd0;
                    end
                end
                
                CALC: begin
                    if (count < 16) begin
                        if (areg[count]) begin
                            accumulator <= accumulator + shifted_b;
                        end
                        count <= count + 1;
                    end
                end
                
                DONE: begin
                    // Hold values for one cycle
                end
            endcase
        end
    end

    // Output assignments
    assign yout = accumulator;
    assign done = (state == DONE);

endmodule