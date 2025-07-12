module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

parameter WIDTH = 512;
parameter CHUNK = 64;  // Processing window size
parameter STEPS = WIDTH/CHUNK;  // 8 steps for 512/64

reg [CHUNK-1:0] processing_window;
reg [CHUNK-1:0] next_window;
reg [2:0] step_counter;
reg computing_phase;

// State machine control
always @(posedge clk) begin
    if (load) begin
        q <= data;
        step_counter <= 0;
        computing_phase <= 1;
    end else begin
        if (computing_phase) begin
            // Load the current processing window
            case (step_counter)
                0: processing_window <= {1'b0, q[CHUNK-1:1]};
                1: processing_window <= {q[CHUNK*1-1], q[CHUNK*1+CHUNK-1:CHUNK*1+1]};
                2: processing_window <= {q[CHUNK*2-1], q[CHUNK*2+CHUNK-1:CHUNK*2+1]};
                3: processing_window <= {q[CHUNK*3-1], q[CHUNK*3+CHUNK-1:CHUNK*3+1]};
                4: processing_window <= {q[CHUNK*4-1], q[CHUNK*4+CHUNK-1:CHUNK*4+1]};
                5: processing_window <= {q[CHUNK*5-1], q[CHUNK*5+CHUNK-1:CHUNK*5+1]};
                6: processing_window <= {q[CHUNK*6-1], q[CHUNK*6+CHUNK-1:CHUNK*6+1]};
                7: processing_window <= {q[CHUNK*7-1], 1'b0};
            endcase
            
            // Compute next state for the window
            for (integer i = 0; i < CHUNK; i = i + 1) begin
                if (i == 0)
                    next_window[i] = (step_counter == 0) ? 1'b0 : q[CHUNK*step_counter-1] ^ processing_window[i+1];
                else if (i == CHUNK-1)
                    next_window[i] = processing_window[i-1] ^ ((step_counter == STEPS-1) ? 1'b0 : q[CHUNK*(step_counter+1)]);
                else
                    next_window[i] = processing_window[i-1] ^ processing_window[i+1];
            end
            
            computing_phase <= 0;
        end else begin
            // Update phase - store the computed window
            case (step_counter)
                0: q[CHUNK-1:0] <= next_window;
                1: q[CHUNK*2-1:CHUNK*1] <= next_window;
                2: q[CHUNK*3-1:CHUNK*2] <= next_window;
                3: q[CHUNK*4-1:CHUNK*3] <= next_window;
                4: q[CHUNK*5-1:CHUNK*4] <= next_window;
                5: q[CHUNK*6-1:CHUNK*5] <= next_window;
                6: q[CHUNK*7-1:CHUNK*6] <= next_window;
                7: q[CHUNK*8-1:CHUNK*7] <= next_window;
            endcase
            
            step_counter <= (step_counter == STEPS-1) ? 0 : step_counter + 1;
            computing_phase <= 1;
        end
    end
end

endmodule