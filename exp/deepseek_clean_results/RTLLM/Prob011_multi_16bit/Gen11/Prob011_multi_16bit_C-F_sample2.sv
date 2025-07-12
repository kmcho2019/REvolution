module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output wire done
);

    // One-hot state encoding
    localparam IDLE = 4'b0001;
    localparam LOAD = 4'b0010;
    localparam CALC = 4'b0100;
    localparam DONE = 4'b1000;
    
    reg [3:0] state;
    reg [4:0] count;
    reg [15:0] areg;
    reg [31:0] accumulator;
    reg [31:0] acc_pipe;
    
    // Shift computation (only when needed)
    wire [31:0] shifted_b = {16'b0, bin} << (count - 1);
    wire shift_en = (state == CALC) && areg[count-1];
    
    // Next state logic
    always @(*) begin
        case (state)
            IDLE: state = start ? LOAD : IDLE;
            LOAD: state = CALC;
            CALC: state = (count == 16) ? DONE : CALC;
            DONE: state = start ? LOAD : IDLE;
            default: state = IDLE;
        endcase
    end
    
    // State transition and datapath
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
            areg <= 16'd0;
            accumulator <= 32'd0;
            acc_pipe <= 32'd0;
            yout <= 32'd0;
        end else begin
            case (state)
                IDLE: begin
                    count <= 5'd0;
                    accumulator <= 32'd0;
                end
                
                LOAD: begin
                    areg <= ain;
                    count <= 5'd1;  // Start counting at 1
                end
                
                CALC: begin
                    if (shift_en) begin
                        acc_pipe <= accumulator + shifted_b;
                    end
                    
                    if (count < 16) begin
                        count <= count + 1;
                        if (shift_en) accumulator <= acc_pipe;
                    end
                end
                
                DONE: begin
                    yout <= accumulator;
                end
            endcase
        end
    end
    
    // Output assignments
    assign done = (state == DONE);

endmodule