module TopModule(
    input           clk,
    input           reset,
    input   [7:0]   in,
    output logic    done
);

logic [1:0] counter;

always_ff @(posedge clk) begin
    if(reset) begin
        counter <= 2'b00; // Reset counter
        done <= 1'b0; // Deassert done
    end
    else begin
        if(in[3]) begin // Check if in[3] = 1
            if(counter == 2'b11) begin // If counter is 3, reset it and assert done
                counter <= 2'b00;
                done <= 1'b1;
            end
            else begin // If counter is not 3, increment it and deassert done
                counter <= counter + 1'b1;
                done <= 1'b0;
            end
        end
        else begin // If in[3] = 0, do nothing
            done <= 1'b0;
        end
    end
end

endmodule