module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    reg [3:0] out_temp;
    reg valid_temp;

    always @(*) begin
        out_temp = 4'd0;
        valid_temp = 1'b0;
        
        // Define the array of known scancodes and their corresponding output values
        reg [7:0] scancodes [0:9];
        reg [3:0] outputs [0:9];
        
        integer i;
        initial begin
            scancodes[0] = 8'h45; outputs[0] = 4'd0;
            scancodes[1] = 8'h16; outputs[1] = 4'd1;
            scancodes[2] = 8'h1e; outputs[2] = 4'd2;
            scancodes[3] = 8'h26; outputs[3] = 4'd3;
            scancodes[4] = 8'h25; outputs[4] = 4'd4;
            scancodes[5] = 8'h2e; outputs[5] = 4'd5;
            scancodes[6] = 8'h36; outputs[6] = 4'd6;
            scancodes[7] = 8'h3d; outputs[7] = 4'd7;
            scancodes[8] = 8'h3e; outputs[8] = 4'd8;
            scancodes[9] = 8'h46; outputs[9] = 4'd9;
        end
        
        for (i = 0; i < 10; i++) begin
            if (code == scancodes[i]) begin
                out_temp = outputs[i];
                valid_temp = 1'b1;
                break;
            end
        end
        
        out = out_temp;
        valid = valid_temp;
    end

endmodule